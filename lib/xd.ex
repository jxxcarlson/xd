defmodule Xd do

    alias Xd.Repo


    def main(args \\ []) do
        args |> parse_args |> process
    end


    def parse_args(argv) do

       parse = OptionParser.parse(argv, switches:
         [help: :boolean,
         get: :boolean,
         render: :boolean],

         aliases: [
             g: :get,
             h: :help,
             r: :render])

       case parse do

         { [help: true], _, _ } -> :help
         { [get: true], args, _} ->  {:get, args}
         { [render: true], args, _ } -> {:render, args}

         _ -> :help

       end

    end

    def display(doc) do
      IO.puts "\n============================="
      IO.puts "Title: #{doc.title}"
      IO.puts "-----------------------------"
      IO.puts "Text: #{doc.text}"
      IO.puts "-----------------------------"
      IO.puts "Rendered Text: #{doc.rendered_text}"
      IO.puts "=============================\n"
    end

    def proj2(x) do
      x[1]
    end

    def process(:help) do
       IO.puts """

       --help              -- display help

       Talk to database:
       --get ID            -- get document with given ID

       Talk to asciidocserver:
       --render ID         -- render text of document with given ID

       Shortcuts:
       -h                   help
       -g                   get document
       -r                   render document

"""
    end

    def process({:get, [id]}) do
       doc = Repo.get(Xd.Document, String.to_integer(id))
       |> display
    end

    def process({:render, [id]}) do
       doc = Repo.get(Xd.Document, String.to_integer(id))

       url = "http://localhost:2300/render"
       headers = [{"Content-type", "application/json"}]

       source_text = doc.text
       IO.puts("\n\nSOURCE TEXT: #{source_text}\n\n")
       body = Poison.encode!(%{"source_text": source_text})

       case HTTPoison.post(url, body, headers) do
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
           body
         {:ok, %HTTPoison.Response{status_code: 404}} ->
           "Not found :("
         {:error, %HTTPoison.Error{reason: reason}} ->
           reason
       end

    end

    ## START ##

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Xd.Supervisor]
    Supervisor.start_link(children, opts)
  end


end







