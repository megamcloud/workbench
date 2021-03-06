defmodule WorkbenchWeb.Time do
  def from_now(%DateTime{} = d) do
    relative = Timex.format!(d, "{relative}", :relative)
    Phoenix.HTML.Tag.content_tag(:span, relative, title: d)
  end
end
