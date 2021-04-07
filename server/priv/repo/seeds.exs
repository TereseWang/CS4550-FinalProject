# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cat.Repo.insert!(%Cat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Cat.Repo
alias Cat.Users.User
alias Cat.Photos

defmodule Inject do
  def photo(name) do
    photos = Application.app_dir(:cat, "priv/photos")
    path = Path.join(photos, name)
    {:ok, hash} = Photos.save_photo(name, path)
    hash
  end

  def user(name, pass, email, reason, photo_hash) do
    hash = Argon2.hash_pwd_salt(pass)
    Repo.insert!(%User{name: name, password_hash: hash, email: email, reason: reason, photo_hash: photo_hash})
  end
end

aaa = Inject.photo("default.jpg")
alice = Inject.user("alice", "test1", "teresewang2000@gmail.com", "", aaa)
