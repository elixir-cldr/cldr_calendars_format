defmodule Cldr.Calendar.Formatter.UnknownFormatterError do
  defexception [:message]

  def exception(message) do
    %__MODULE__{message: message}
  end
end

defmodule Cldr.Calendar.Formatter.InvalidDateError do
  defexception [:message]

  def exception(message) do
    %__MODULE__{message: message}
  end
end

defmodule Cldr.Calendar.Formatter.InvalidOption do
  defexception [:message]

  def exception(message) do
    %__MODULE__{message: message}
  end
end