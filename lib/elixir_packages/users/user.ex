defmodule ElixirPackages.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  # Explicitly remove `:pow_fields` used for adding and validating Pow fields
  Module.delete_attribute(__MODULE__, :pow_fields)

  schema "users" do
    has_many :user_identities, ElixirPackages.UserIdentities.UserIdentity, on_delete: :delete_all

    field :email, :string, null: false
    field :role, :string, null: false, default: "user"

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_user_id_field_changeset(attrs)
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end
end
