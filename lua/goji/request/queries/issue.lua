local M = {}

function M.get_issue_details()
  return [[
    issueByKey(cloudId: $cloudId, key: $key) {
      id
      webUrl
      key
      fields {
        edges {
          node {
            id
            name
            type
            description
            ... on JiraRichTextField {
              richText {
                adfValue {
                  convertedPlainText {
                    plainText
                  }
                }
              }
            }
            ... on JiraSingleLineTextField {
              text
            }
          }
        }
      }
    }
    ]]
end

return M
