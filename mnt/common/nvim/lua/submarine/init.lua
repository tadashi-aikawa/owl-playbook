local curl = require("plenary.curl")

local function print_table(t, indent)
  indent = indent or ""
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(indent .. k .. ":")
      print_table(v, indent .. "  ")
    else
      print(indent .. k .. ": " .. tostring(v))
    end
  end
end

local function until_delimiter(arr, delimiter)
  local result = {}
  for i, value in ipairs(arr) do
    if value == delimiter then
      break
    end
    table.insert(result, value)
  end
  return result
end

local function double_indent(line)
  local leading_spaces = line:match("^%s*")
  local doubled_spaces = leading_spaces .. leading_spaces
  return doubled_spaces .. line:sub(#leading_spaces + 1)
end

local function convert_link_format(input)
  return input:gsub("%[(.+)%]%((.+)%)", "<%2|%1>")
end

-- ここから本筋

local function get_token()
  return vim.fn.getenv("SLACK_USER_TOKEN")
end

local function post_message(channel_id, message)
  local response = curl.post({
    url = "https://slack.com/api/chat.postMessage",
    headers = {
      ["Content-Type"] = "application/json; charset=UTF-8",
      ["Authorization"] = "Bearer " .. get_token(),
    },
    body = vim.fn.json_encode({
      channel = channel_id,
      text = message,
    }),
  })

  return vim.fn.json_decode(response.body)
end

local function delete_message(channel_id, ts)
  local response = curl.post({
    url = "https://slack.com/api/chat.delete",
    headers = {
      ["Content-Type"] = "application/json; charset=UTF-8",
      ["Authorization"] = "Bearer " .. get_token(),
    },
    body = vim.fn.json_encode({
      channel = channel_id,
      ts = ts,
    }),
  })

  return vim.fn.json_decode(response.body)
end

local function pick_channel_and_ts(str)
  local channel_id, message_id = str:match("https://%w+.slack.com/archives/(%w+)/p(%d+)")
  if channel_id and message_id then
    local ts = message_id:sub(1, 10) .. "." .. message_id:sub(11)
    return channel_id, ts
  end

  -- urlでない場合はchannel_id,ts形式
  local channel_id2, ts = unpack(vim.split(str, ","))
  if not channel_id2 or not ts then
    error("Invalid URL format")
  end

  return channel_id2, ts
end

local function post_current_buf()
  local cbuf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(cbuf, 0, -1, false)
  if #lines == 0 then
    return
  end

  -- ex: https://minerva.slack.com/archives/C1J80C5MF/p1722259290076499
  local url = lines[1]

  -- "---"より前
  local body_lines = vim.tbl_map(function(line)
    line = string.gsub(line, "- %[~%] ", ":spinner-ripple: ")
    line = string.gsub(line, "- %[x%] ", ":done: ")
    line = string.gsub(line, "- %[ %] ", ":circle-failure: ")

    return double_indent(convert_link_format(line))
  end, until_delimiter({ unpack(lines, 3) }, "---"))
  local contents = table.concat(body_lines, "\n")

  local channel_id, ts = pick_channel_and_ts(url)

  local res1 = delete_message(channel_id, ts)
  if not res1.ok then
    error(print_table(res1, 2))
  end

  local res2 = post_message(channel_id, contents)
  if not res2.ok then
    -- TODO: ここで完了させられる旨を書く
    error(print_table(res2, 2))
  end

  vim.api.nvim_buf_set_lines(cbuf, 0, 1, false, { res2.channel .. "," .. res2.ts })
end

local function run()
  vim.api.nvim_echo({ { "Notify to slack ...", "Normal" } }, false, {})
  post_current_buf()
  vim.api.nvim_echo({ { "✔️  Success", "Normal" } }, false, {})
end

return { run = run }
