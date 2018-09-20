defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.double(x)
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc(expr)
    render conn, "calc.html", expr: expr, y: y
  end

  def factor(conn, %{"x" => x}) do
    {num, _} = Integer.parse(x)
    y = Practice.factor(num)
    render conn, "factor.html", num: x, factors: y
  end

  def palindrome(conn, %{"str" => str}) do
    is_palindrome = Practice.palindrome?(str)
    answer = case is_palindrome do
      true -> "\"#{(str)}\" is a palindrome!"
      false ->  "\"#{(str)}\" is not a palindrome."
    end
    render conn, "palindrome.html", answer: answer
  end
end
