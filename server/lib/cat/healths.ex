defmodule Cat.Healths do
  @moduledoc """
  The Healths context.
  """

  import Ecto.Query, warn: false
  alias Cat.Repo

  alias Cat.Healths.Health

  @doc """
  Returns the list of healths.

  ## Examples

      iex> list_healths()
      [%Health{}, ...]

  """
  def load_user(%Health{} = health) do
    Repo.preload(health, :user)
  end

  def load_comments(%Health{} = health) do
    Repo.preload(health, [comments: :user])
  end

  def list_healths do
    Repo.all(Health)
    |> Repo.preload(:user)
    |> Repo.preload([comments: :user])
  end

  @doc """
  Gets a single health.

  Raises `Ecto.NoResultsError` if the Health does not exist.

  ## Examples

      iex> get_health!(123)
      %Health{}

      iex> get_health!(456)
      ** (Ecto.NoResultsError)

  """
  def get_health!(id) do
    Repo.get!(Health, id)
    |> Repo.preload(:user)
    |> Repo.preload([comments: :user])
  end

  @doc """
  Creates a health.

  ## Examples

      iex> create_health(%{field: value})
      {:ok, %Health{}}

      iex> create_health(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_health(attrs \\ %{}) do
    %Health{}
    |> Health.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a health.

  ## Examples

      iex> update_health(health, %{field: new_value})
      {:ok, %Health{}}

      iex> update_health(health, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_health(%Health{} = health, attrs) do
    health
    |> Health.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a health.

  ## Examples

      iex> delete_health(health)
      {:ok, %Health{}}

      iex> delete_health(health)
      {:error, %Ecto.Changeset{}}

  """
  def delete_health(%Health{} = health) do
    Repo.delete(health)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking health changes.

  ## Examples

      iex> change_health(health)
      %Ecto.Changeset{data: %Health{}}

  """
  def change_health(%Health{} = health, attrs \\ %{}) do
    Health.changeset(health, attrs)
  end
end
