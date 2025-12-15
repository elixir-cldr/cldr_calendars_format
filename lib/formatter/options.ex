defmodule Cldr.Calendar.Formatter.Options do
  @moduledoc """
  Defines and validates the options
  for a calendar formatter.

  These options are passed to the formatter
  callbacks defined in `Cldr.Calendar.Formatter`.

  The valid options are:

  * `:calendar` is an calendar module defined with
    `use Cldr.Calendar`.

  * `:backend` is any module that applied
    `use Cldr`.  The default is `Cldr.default_backend()`.

  * `:formatter` is any module implementing the
    `Cldr.Calendar.Formatter` behaviour.

  * `:locale` is any locale returned by `Cldr.validate_locale/1`.
    The default is `Cldr.get_locale()`.

  * `:number_system` is any valid number system name
    or number system type for the given locale.
    Available number systems for a locale are returned by
    `Cldr.Number.System.number_systems_for(locale, backend)`.
    The default is `:default`.

  * `:territory` is any territory returned by `Cldr.validate_territory/1`
    The default is `Cldr.Locale.territory_from_locale/1`.

  * `:caption` is a caption to be applied in any way defined
    by the `:formatter`. The default is `nil`.

  * `:class` is a class name that can be used any way
    defined by the `:formatter`.  It is most commonly
    used to apply an HTML class to an enclosing tag. The
    default is `Cldr.Calendar.Format.default_calendar_css_class/0`

  * `:id` is an id that can be used any way
    defined by the `:formatter`.  It is most commonly
    used to apply an HTML id to an enclosing tag. The
    default is `nil`

  * `:private` is for your private use in your formatter.
    For example if you wanted to pass a selected day and
    format it differently, you could provide
    `options.private = %{selected: ~D[2020-04-05]}` and
    take advantage of it while formatting the days.

  * `:today` is any `Date.t` that represents today.
    It is commonly used to allow a formatting to
    appropriately format a date that is today
    differently to other days on a calendar. The
    default is `Date.utc_today/0`

  * `:day_names` is an ordered list of seven 2-tuples that
    map the day of the week to a localised day
    name. These are most often used as headers
    for a month. The default is automatically
    calculated from the provided `:calendar`
    and `:locale`. An example could be:
    `[{1, "one"}, {2, "two"}, ..., {7, "sevem"}]`.

  """
  @valid_options [
    :backend,
    :locale,
    :calendar,
    :caption,
    :class,
    :day_names,
    :formatter,
    :id,
    :number_system,
    :private,
    :territory,
    :today
  ]

  defstruct @valid_options

  @typedoc """
  Formatter options

  """
  @type t :: %__MODULE__{
    calendar: module(),
    number_system: Cldr.Number.System.system_name(),
    territory: atom() | String.t(),
    locale: Cldr.LanguageTag.t(),
    formatter: module(),
    backend: module(),
    caption: String.t | nil,
    class: String.t | nil,
    id: String.t | nil,
    today: Date.t(),
    private: any(),
    day_names: [{1..7, String.t}]
  }

  alias Cldr.Number

  @doc false
  def validate_options(options) when is_list(options) do
    options =
      Enum.reduce_while(@valid_options, options, fn option, options ->
        case validate_option(option, options, Keyword.get(options, option)) do
          {:ok, value} -> {:cont, Keyword.put(options, option, value)}
          other -> {:halt, other}
        end
      end)

    case options do
      {:error, _} = error -> error
      valid_options -> {:ok, struct(__MODULE__, valid_options)}
    end
  end

  def validate_option(:calendar, _options, nil) do
    {:ok, Cldr.Calendar.default_calendar()}
  end

  def validate_option(:calendar, _options, Calendar.ISO) do
    {:ok, Cldr.Calendar.default_calendar()}
  end

  def validate_option(:calendar, _options, calendar) do
    with {:ok, calendar} <- Cldr.Calendar.validate_calendar(calendar) do
      {:ok, calendar}
    end
  end

  def validate_option(:number_system, options, nil) do
    locale = Keyword.get(options, :locale)
    backend = Keyword.get(options, :backend)

    {:ok, Number.System.number_system_from_locale(locale, backend)}
  end

  def validate_option(:number_system, options, number_system) do
    locale = Keyword.get(options, :locale)
    backend = Keyword.get(options, :backend)

    with {:ok, number_system} <- Number.validate_number_system(locale, number_system, backend) do
      {:ok, number_system}
    end
  end

  def validate_option(:territory, options, nil) do
    locale = Keyword.get(options, :locale)

    {:ok, Cldr.Locale.territory_from_locale(locale)}
  end

  def validate_option(:backend, _options, nil) do
    {:ok, Cldr.default_backend!()}
  end

  def validate_option(:backend, _options, backend) do
    with {:ok, backend} <- Cldr.validate_backend(backend) do
      {:ok, backend}
    end
  end

  def validate_option(:formatter, _options, nil) do
    {:ok, Cldr.Calendar.Format.default_formatter_module()}
  end

  def validate_option(:formatter, _options, formatter) do
    if Cldr.Calendar.Format.formatter_module?(formatter) do
      {:ok, formatter}
    else
      {:error, Cldr.Calendar.Format.invalid_formatter_error(formatter)}
    end
  end

  def validate_option(:locale, options, nil) do
    backend = Keyword.get(options, :backend)

    {:ok, backend.get_locale()}
  end

  def validate_option(:locale, options, locale) do
    backend = Keyword.get(options, :backend)

    with {:ok, locale} <- Cldr.validate_locale(locale, backend) do
      {:ok, locale}
    end
  end

  def validate_option(:today, _options, nil) do
    {:ok, Date.utc_today}
  end

  def validate_option(:today, _options, date) do
    if is_map(date) and Map.has_key?(date, :year) and
        Map.has_key?(date, :month) and Map.has_key?(date, :day) do
          {:ok, date}
    else
      {:error, Cldr.Calendar.Format.invalid_date_error(date)}
    end
  end

  def validate_option(:class, _options, nil) do
    {:ok, Cldr.Calendar.Format.default_calendar_css_class()}
  end

  def validate_option(:class, _options, class) do
    {:ok, class}
  end

  def validate_option(:caption, _options, nil) do
    {:ok, nil}
  end

  def validate_option(:caption, _options, caption) do
    {:ok, caption}
  end

  def validate_option(:id, _options, nil) do
    {:ok, nil}
  end

  def validate_option(:id, _options, id) do
    {:ok, id}
  end

  def validate_option(:private, _options, nil) do
    {:ok, nil}
  end

  def validate_option(:private, _options, private) do
    {:ok, private}
  end

  def validate_option(:day_names, options, nil) do
    backend = Keyword.get(options, :backend)
    locale = Keyword.get(options, :locale)

    {:ok, date} = Date.new(2000, 1, 1, Keyword.get(options, :calendar))
    {:ok, Cldr.Calendar.localize(date, :days_of_week, backend: backend, locale: locale)}
  end

  day_names = quote do
    [{1, _}, {2, _}, {3, _}, {4, _}, {5, _}, {6, _}, {7, _}]
  end

  def validate_option(:day_names, _options, unquote(day_names) = day_names) do
    {:ok, day_names}
  end

  def validate_option(option, _options, any) do
    {:error, {Cldr.Calendar.Formatter.InvalidOption,
      "Invalid option or option value. Found option #{inspect option} with value #{inspect any}"}}
  end
end
