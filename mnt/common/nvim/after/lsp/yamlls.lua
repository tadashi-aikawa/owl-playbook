return {
  settings = {
    yaml = {
      customTags = {
        "!ENV scalar",
        "!ENV sequence",
      },
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas({
        extra = {
          {
            description = "Bitbucke Pipelines",
            fileMatch = "bitbucket-pipelines.yml",
            name = "bitbucket-pipelines.yml",
            url = "https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/f9f41a5d1e7b3d25236b15296eb26eba426c6895/src/main/resources/schemas/bitbucket-pipelines.schema.json",
          },
        },
      }),
    },
  },
}
