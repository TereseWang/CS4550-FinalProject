#Meta:
## Who was on your team?
- Just myself
## What’s the URL of your deployed app?
- http://kittenlover.teresewang.com/

## What’s the URL of your github repository with the code for your deployed app?
- https://github.com/TereseWang/CS4550-FinalProject

## Is your app deployed and working?
- Yes, both for front end and back end

## For each team member, what work did that person do on the project?
- It's only myself, so everything


#App:
## What does your project 2 app do?
- This will be a cat website, that provide people with the ability to share their
knowledge about the cat, which people will be able to post different things and to
like or dislike some post, and posts will be queried up according to the number of likes.
There will be three different kinds of post, which one is for forum dicussion, one
if for cat wellness behavior and the other one will be for food recommendation.
Last, I also had this page that connect to the other web api portal , which basically
will render all the cat adoption information in America, I had thought of adding a
query system, but not enough time.

## How has your app concept changed since the proposal?
- Not really, due to the time reason, I am not being able to finish the lost/found
cat post part, and also for the adoption part i don't have time to integrate the
cat selling part also and didn't get chance to play with the post functionality of that
cat web api.

## How do users interact with your application? What can they accomplish by doing so?
Users is being able to create post, comment the post, like or dislike the post
and also is able to search with the key words in wellness page. By doing so,
users is able to share their knowledge about the cat and also talking with others
who also have cats. Moreover, user can look at the adoption info part which i
find really helpful if you really wanna adopt a cat, and it will direct u to the
formal page and showing other information necessary

## For each project requirement above, how does your app meet that requirement?
- The app is build with two component, which one is the server holding data
and the other one is the front end that get the data from the server with spa redux structure . It is
built with JSON API authenticated with JWTs. The two server is communicating through
JSON API and Channels. It do have user accounts with local password authentication and everything
is stored in postgres database.  I did use the store to push realtime updates when everytime
there's a update.

## What interesting stuff does your app include beyond the project requirements?
 I did use a external Api portal, and you have to do an authentication in order
to access the data, but the data is free overall. And I added the search and auto query functionality
and tried to make the overall web looks nice and neat.

## What’s the complex part of your app? How did you design that component and why?
- I think the most time consuming part is putting everything together nicely, since there
are a lot of stuff and also trying to get the authentication part work when acessing
external api from other website, since it tooks me time to find a nice api and also
find documentation on how to use fetch

## What was the most significant challenge you encountered and how did you solve it?
- I am not quit familiar with the spa and redux, which it takes a me a quit while to figure them out
and connect them together, what I did is keep looking the lecture notes, and tries to compare
each days lectures, seeing what professor has done and tries to expand on that.
