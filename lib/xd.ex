defmodule Xd do


    def main(args \\ []) do
        args |> parse_args |> process
    end


    def parse_args(argv) do

       parse = OptionParser.parse(argv, switches:
         [help: :boolean,
         render: :boolean],

         aliases: [
             h: :help,
             r: :render])

       case parse do

         { [help: true], _, _ } -> :help
         { [get: true], args, _} ->  {:get, args}
         { [render: true], args, _ } -> {:render, args}

         _ -> :help

       end

    end

    def process(:help) do
       IO.puts "No help yet"
    end

    def process(:get, args) do
       IO.puts "get #{args}"
    end

    def process(:render, args) do
       IO.puts "get #{args}"
    end


end







