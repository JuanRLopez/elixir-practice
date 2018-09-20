defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    IO.puts "[BEGIN CALC]"

    answer = expr
    |> String.split
    |> Enum.map(fn x ->
         IO.puts "[MAPPING PARTS...] #{x}"
         cond do
           # check if it is an operation
           Enum.member?(["+", "-", "*", "/"], x) -> {:op, x}

           # check if its a number
           x |> String.split("", trim: true)
           |> Enum.all?(fn y -> Enum.member?(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], y) end) ->
             {:num, String.to_integer(x)}
         end
      end
      )
    |> convert_to_postfix
    |> process_expr

    IO.puts "[END CALC]"
    answer
  end

  # converts an arithmetic expression string into postfix form
  def convert_to_postfix(expr) do
    IO.puts "[BEGIN CONVERSION]"
    op_value = %{"*" => 2, "/" => 2, "+" => 1, "-" => 1}

    {answer, op_stack} = Enum.reduce(expr, {[], []}, fn ({type, data}, {acc_answer, acc_op_stack}) ->
        cond do
          # handle numbers
          type == :num -> {acc_answer ++ [{type, data}], acc_op_stack}

          # handle operations
          type == :op ->
            cond do
              # is the op stack empty?
              Enum.empty?(acc_op_stack) -> {acc_answer, acc_op_stack ++ [{type, data}]}

              # is the current op of greater presedance than the head of the op stack?
              op_value[data] >= op_value[elem(hd(acc_op_stack), 1)] ->
                {acc_answer, List.insert_at(acc_op_stack, 0, {type, data})}

              # is the current op of lesser presedance than the head of the op stack?
              op_value[data] < op_value[elem(hd(acc_op_stack), 1)] ->
                other_op = hd(acc_op_stack)
                new_answer = acc_answer ++ [other_op]
                new_op_stack = List.delete_at(acc_op_stack, 0)
                new_op_stack = List.insert_at(new_op_stack, 0, {type, data})
                {new_answer, new_op_stack}
              end
            end
        end
      )
    IO.puts "[END CONVERSION]: #{inspect(answer ++ op_stack)}"
    answer ++ op_stack
  end

  # processes an arithmetic expression in postfix form
  def process_expr(expr) do
    IO.puts "[BEGIN TO PROCESS]"
    stack = Enum.reduce(expr, [], fn ({type, data}, acc) ->
       cond do
        # insert numbers in stack
        type == :num -> List.insert_at(acc, 0, data)

        # process operation
        type == :op ->
          temp_stack = acc
          x = hd(temp_stack)
          temp_stack = List.delete_at(temp_stack, 0)
          y = hd(temp_stack)
          temp_stack = List.delete_at(temp_stack, 0)

          answer = compute(data, y, x)
          List.insert_at(temp_stack, 0, answer)
        end
      end
      )
    IO.puts "[END PROCESS]"
    hd(stack)
  end

  # computes the arithmetic supported.
  def compute(op, x, y) do
    cond do
      op == "*" -> x * y
      op == "/" -> x / y
      op == "+" -> x + y
      op == "-" -> x - y
    end
  end

  # finds the prime factors of a number
  def factor(x) do
    answer = factor(x, 2, [])
  end

  def factor(x, div, acc) do
    answer = cond do
      x > 1 ->
        cond do
          rem(x, div) == 0 -> factor(div(x, div), 2, acc ++ [div])
          rem(x, div) != 0 -> factor(x, div + 1, acc)
        end

      x <= 1 -> acc
    end

    IO.puts "Actual list: #{inspect(answer)}"
    answer
  end
end
