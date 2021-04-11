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
alias Cat.Healths.Health
alias Cat.Comments.Comment
alias Cat.Forums.Forum
alias Cat.Forumcomments.Forumcomment
alias Cat.Foods.Food

defmodule Inject do
  def photo(name) do
    photos = Application.app_dir(:cat, "priv/photos")
    path = Path.join(photos, name)
    {:ok, hash} = Photos.save_photo(name, path)
    hash
  end

  def user(name, pass, email, reason, photo_hash) do
    hash = Argon2.hash_pwd_salt(pass)
    Repo.insert!(%User{name: name, password_hash: hash, email: email,
    reason: reason, photo_hash: photo_hash})
  end
end

aaa = Inject.photo("default.jpg")
alice = Inject.user("alice", "test1", "teresewang2000@gmail.com", "", aaa)
bob = Inject.user("bob", "test1", "wang.haoqi@northeastern.edu", "", aaa)
cindy = Inject.user("cindy", "test1", "aaa@gmail.com", "", aaa)
bbb = Inject.photo("cat-behavior-issues.jpg")
p1 = %Health {
  user_id: alice.id,
  body: "Normal Cat Behavior

Cats, like people, have unique personalities and characteristics. Therefore, there is no definitive list of “normal” cat behavior. While there are many common feline behaviors, keep in mind that each cat is special and may act in ways that are slightly different due to their personality, environment or mood. For example, the most common cat behaviors include purring, grooming, kneading and climbing. But each cat will engage in these activities differently. Pay attention to your cat’s behavior and determine what is “normal” for your cat so you can be aware of unusual behavior that may require a trip to the vet.

Cat Purring

Most people consider purring to be a universal sign that a cat is happy and content. For the most part, cats will purr when they are comfortable and happy. Cats often purr when being pet, enjoying the sunshine or sitting on your laptop computer as you try to work. Purring, however, can also be a sign of stress due to unfamiliar situations or surroundings. It can also be when your cat is sick or injured. When a cat purrs, the vibrating cords in the larynx create vibrations across the cat’s entire body that can be soothing in a stressful situation. If your cat is purring excessively or in situations where purring is not common, it could be a sign of illness or injury. Thoroughly examine your cat or take them to a veterinarian especially if the cat is not eating, drinking or otherwise acting “normal.”

Feline Grooming

Cats also typically spend a great deal of time grooming. For some cats, grooming can take up to 50 percent of their time. Grooming helps cats stay tidy, but their saliva also helps insulate their bodies and keep them warm. So, you may see your cat grooming more in cold weather. Each cat will have different grooming habits and patterns, so pay attention to your cat’s beauty regime. If grooming is excessive (overall or in a certain area) or causes loss of fur, you should bring your cat to the veterinarian for an examination.",
  photo_hash: bbb,
  title: "Cat Behavior"
}
p2 = %Health {
  user_id: bob.id,
  body: "Normal Cat Behavior

Cats, like people, have unique personalities and characteristics. Therefore, there is no definitive list of “normal” cat behavior. While there are many common feline behaviors, keep in mind that each cat is special and may act in ways that are slightly different due to their personality, environment or mood. For example, the most common cat behaviors include purring, grooming, kneading and climbing. But each cat will engage in these activities differently. Pay attention to your cat’s behavior and determine what is “normal” for your cat so you can be aware of unusual behavior that may require a trip to the vet.

Cat Purring

Most people consider purring to be a universal sign that a cat is happy and content. For the most part, cats will purr when they are comfortable and happy. Cats often purr when being pet, enjoying the sunshine or sitting on your laptop computer as you try to work. Purring, however, can also be a sign of stress due to unfamiliar situations or surroundings. It can also be when your cat is sick or injured. When a cat purrs, the vibrating cords in the larynx create vibrations across the cat’s entire body that can be soothing in a stressful situation. If your cat is purring excessively or in situations where purring is not common, it could be a sign of illness or injury. Thoroughly examine your cat or take them to a veterinarian especially if the cat is not eating, drinking or otherwise acting “normal.”

Feline Grooming

Cats also typically spend a great deal of time grooming. For some cats, grooming can take up to 50 percent of their time. Grooming helps cats stay tidy, but their saliva also helps insulate their bodies and keep them warm. So, you may see your cat grooming more in cold weather. Each cat will have different grooming habits and patterns, so pay attention to your cat’s beauty regime. If grooming is excessive (overall or in a certain area) or causes loss of fur, you should bring your cat to the veterinarian for an examination.",
  photo_hash: bbb,
  title: "Cat Behavior"
}
p3 = %Health {
  user_id: cindy.id,
  body: "Normal Cat Behavior

Cats, like people, have unique personalities and characteristics. Therefore, there is no definitive list of “normal” cat behavior. While there are many common feline behaviors, keep in mind that each cat is special and may act in ways that are slightly different due to their personality, environment or mood. For example, the most common cat behaviors include purring, grooming, kneading and climbing. But each cat will engage in these activities differently. Pay attention to your cat’s behavior and determine what is “normal” for your cat so you can be aware of unusual behavior that may require a trip to the vet.

Cat Purring

Most people consider purring to be a universal sign that a cat is happy and content. For the most part, cats will purr when they are comfortable and happy. Cats often purr when being pet, enjoying the sunshine or sitting on your laptop computer as you try to work. Purring, however, can also be a sign of stress due to unfamiliar situations or surroundings. It can also be when your cat is sick or injured. When a cat purrs, the vibrating cords in the larynx create vibrations across the cat’s entire body that can be soothing in a stressful situation. If your cat is purring excessively or in situations where purring is not common, it could be a sign of illness or injury. Thoroughly examine your cat or take them to a veterinarian especially if the cat is not eating, drinking or otherwise acting “normal.”

Feline Grooming

Cats also typically spend a great deal of time grooming. For some cats, grooming can take up to 50 percent of their time. Grooming helps cats stay tidy, but their saliva also helps insulate their bodies and keep them warm. So, you may see your cat grooming more in cold weather. Each cat will have different grooming habits and patterns, so pay attention to your cat’s beauty regime. If grooming is excessive (overall or in a certain area) or causes loss of fur, you should bring your cat to the veterinarian for an examination.",
  photo_hash: bbb,
  title: "Cat Behavior",
  votes: []
}
Repo.insert!(p1)
Repo.insert!(p2)
Repo.insert!(p3)

c1 = %Comment {
  user_id: alice.id,
  health_id: 1,
  body: "I like your article",
}
Repo.insert!(c1)
f1 = %Forum {
  user_id: cindy.id,
  body: "Quick Question",
  photo_hash: bbb,
  title: "Quick Question",
  votes: []
}

f2 = %Forum {
  user_id: alice.id,
  body: "My Cat",
  photo_hash: bbb,
  title: "My Cat",
  votes: []
}

c2 = %Forumcomment {
  user_id: alice.id,
  forum_id: 1,
  body: "I like your article",
}
Repo.insert!(f1)
Repo.insert!(f2)
Repo.insert!(c2)
food1 = %Food {
  user_id: alice.id,
  brand: "Feast",
  price: 10,
  photo_hash: bbb,
  type: "kitten food",
  body: "good for kitten, once per day",
  like: [],
  dislike: [],
}
Repo.insert!(food1)

food2 = %Food {
  user_id: alice.id,
  brand: "Feast",
  price: 10,
  photo_hash: bbb,
  type: "kitten food",
  body: "good for kitten, once per day",
  like: [],
  dislike: [],
}
Repo.insert!(food2)

food3 = %Food {
  user_id: alice.id,
  brand: "Feast",
  price: 10,
  photo_hash: bbb,
  type: "kitten food",
  body: "good for kitten, once per day",
  like: [],
  dislike: [],
}
Repo.insert!(food3)
