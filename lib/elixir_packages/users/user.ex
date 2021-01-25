defmodule ElixirPackages.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  # Explicitly remove `:pow_fields` used for adding and validating Pow fields
  Module.delete_attribute(__MODULE__, :pow_fields)

  schema "users" do
    has_many :user_identities, ElixirPackages.UserIdentities.UserIdentity, on_delete: :delete_all

    field :email, :string, null: false

    timestamps()
  end
end
