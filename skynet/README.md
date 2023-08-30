# Skynet
Step 1
Project creation. I made sure to remove a lot of the unnecessary files as this is just an API with no need for
LiveView or any styling.
`mix phx.new skynet --no-html --no-live --no-assets --no-dashboard --no-ecto --no-mailer`

Step 2
Configure the Skynet Server to start on application start and build the actual server module.
This was an interesting problem made fun by picturing my code creating robots and having them possibly be destroyed.

The first thing I did was create the basic functions to handle creating, killing, and listing them all out. 
Had to do a quick Google search on how to keep the IDs from duplicating (only minor setback here)

Second, I wanted to write the functions that would get called repeatably using `handle_info` and triggering them
with a `Process.send_after()`. After that was triggered on a manual terminator build, I added the conditional logic
to kill or reproduce a terminator but the process was still somewhat manual. The only other setback I ran into was getting all of this to
run in a recurring loop from the get-go. After a bit of time, I figured out that making sure those `maybe_` functions had to be triggered in the `init()`.
After adding some fun `IO.inspect()` I was finally able to witness the end of the world with the reproduction/destruction of terminators.
However, once in a while, the first terminator would get killed before it could be reproduced so I threw in a conditional to keep the process alive.
Lastly, I added the `@spec` and `@impl` tags.

Step 3
Updated the router to have the GET POST and DELETE routes. This part was relatively easy because I left it fairly barebones. I spent most of the
time on the Server aspect of the test. I followed these up with very simple controller functions and barebone tests




To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
