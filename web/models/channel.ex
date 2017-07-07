defmodule SpectoPusher.Channel do
  use SpectoPusher.Web, :model

  schema "channels" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def by_name(query, name) do
    from c in query,
    where: c.name == ^name
  end
end
