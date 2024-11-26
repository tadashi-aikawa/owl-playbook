import { Client } from "https://deno.land/x/mysql/mod.ts";

const client = await new Client().connect({
  hostname: "db",
  port: 3306,
  username: "user",
  password: "password",
  db: "mydb",
});

async function handler(request: Request): Promise<Response> {
  const url = new URL(request.url);
  const table = url.searchParams.get("table");
  const result = await client.execute(`select * from ??`, [table]);
  return Response.json(result.rows);
}

Deno.serve(handler);
