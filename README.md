# ElixirPackages

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Development

This is a standard Phoenix app, so you can use all the usual mix commands.

You will have to set up your secrets in `config/dev.secret.exs`.

It may be useful to ignore local file changes for `dev.secret.exs`, as to avoid committing your secrets. This can be done with the command:

```
git update-index --assume-unchanged config/dev.secret.exs
```
