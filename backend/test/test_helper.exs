Bureaucrat.start(
  writer: Bureaucrat.MarkdownWriter,
  default_path: "docs/APIDOCS.md",
  paths: [])
ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Ecto.Adapters.SQL.Sandbox.mode(Backend.Repo, :manual)
