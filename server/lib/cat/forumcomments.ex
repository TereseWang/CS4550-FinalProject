defmodule Cat.Forumcomments do
  @moduledoc """
  The Forumcomments context.
  """

  import Ecto.Query, warn: false
  alias Cat.Repo

  alias Cat.Forumcomments.Forumcomment

  @doc """
  Returns the list of forumcomment.

  ## Examples

      iex> list_forumcomment()
      [%Forumcomment{}, ...]

  """
  def list_forumcomment do
    Repo.all(Forumcomment)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single forumcomment.

  Raises `Ecto.NoResultsError` if the Forumcomment does not exist.

  ## Examples

      iex> get_forumcomment!(123)
      %Forumcomment{}

      iex> get_forumcomment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_forumcomment!(id), do: Repo.get!(Forumcomment, id)

  @doc """
  Creates a forumcomment.

  ## Examples

      iex> create_forumcomment(%{field: value})
      {:ok, %Forumcomment{}}

      iex> create_forumcomment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_forumcomment(attrs \\ %{}) do
    %Forumcomment{}
    |> Forumcomment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a forumcomment.

  ## Examples

      iex> update_forumcomment(forumcomment, %{field: new_value})
      {:ok, %Forumcomment{}}

      iex> update_forumcomment(forumcomment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_forumcomment(%Forumcomment{} = forumcomment, attrs) do
    forumcomment
    |> Forumcomment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a forumcomment.

  ## Examples

      iex> delete_forumcomment(forumcomment)
      {:ok, %Forumcomment{}}

      iex> delete_forumcomment(forumcomment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_forumcomment(%Forumcomment{} = forumcomment) do
    Repo.delete(forumcomment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking forumcomment changes.

  ## Examples

      iex> change_forumcomment(forumcomment)
      %Ecto.Changeset{data: %Forumcomment{}}

  """
  def change_forumcomment(%Forumcomment{} = forumcomment, attrs \\ %{}) do
    Forumcomment.changeset(forumcomment, attrs)
  end
end
