import store from './store';

async function api_get(path) {
  let text = await fetch(
    "http://localhost:4000/api/v1" + path, {});
  let resp = await text.json();
  return resp.data;
}

async function api_post(path, data) {
  let opts = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data),
  };
  let text = await fetch(
    "http://localhost:4000/api/v1" + path, opts);
  return await text.json();
}
//-----------------------Forum----------------------------------
export function fetch_forums() {
  api_get("/forums").then((data) => {
  data = sortForum(data)
  store.dispatch({
    type: 'forums/set',
    data: data,
  })});
}

export function fetch_forum(id) {
  api_get("/forums/"+id).then((data) => store.dispatch({
    type: 'forum_form/set',
    data: data,
  }));
}

export async function create_forum(post) {
  let data = new FormData();
  data.append("forum[user_id]", post.user_id);
  data.append("forum[title]", post.title);
  data.append("forum[body]", post.body);
  data.append("forum[votes]", JSON.stringify([]))
  if (post.photo === "undefined") {
    post["photo"] = "";
  }
  data.append("forum[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/forums", {
    method: "POST",
    body: data,
  })
return await resp.json();
}

export async function update_forum(post) {
  let data = new FormData();
  data.append("forum[user_id]", post.user_id);
  data.append("forum[title]", post.title);
  data.append("forum[body]", post.body);
  data.append("forum[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/forums/" + post.id, {
    method: "PATCH",
    body: data,
  })
return await resp.json();
}

export async function delete_forum(id) {
  let data = new FormData();
  data.append("id", id);
  fetch("http://localhost:4000/api/v1/forums/" + id, {
    method: 'DELETE',
    body: data,
  }).then((resp) => {
    if(!resp.ok){
      let action = {
        type: 'error/set',
        data: 'Unable to delete event.',
      };
      store.dispatch(action);
    }else {
      fetch_forums();
    }
  });
}

export async function update_forum_vote(post, user_id, action) {
  let data = new FormData();
  data.append("forum[user_id]", post.user_id);
  data.append("forum[title]", post.title);
  data.append("forum[body]", post.body);
  let votes = post.votes
  if (action == "increase") {
    votes.push(user_id)
  }
  else {
    votes = votes.filter(function(e) { return e != user_id })
  }
  data.append("forum[votes]", JSON.stringify(votes))
  if (post.photo === "undefined") {
    post["photo"] = "";
  }
  data.append("forum[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/forums/" + post.id, {
    method: "PATCH",
    body: data,
  })
return await resp.json();
}

export function fetch_forum_score(id) {
  api_get("/forums/"+id).then((data) => {
  store.dispatch({
    type: 'forum_score/set',
    data: data.votes.length,
  })});
}

function sortForum(data) {
  return data.sort(function(a, b){
    return b.votes.length - a.votes.length});
}
//----------------------Wellness Comments -----------------------
export function fetch_comments(health_id) {
  api_get("/comments").then((data) => {
    let result = []
    for (let [key, value] of Object.entries(data)) {
      if (value.health_id == health_id) {
        result.push(value)
      }
    }
    store.dispatch({
    type: 'comments/set',
    data: result,
  })})
}

export async function create_comment(comment, user_id, wellness_id) {
  let data = new FormData();
  data.append("comment[body]", comment);
  data.append("comment[health_id]", wellness_id);
  data.append("comment[user_id]", user_id);
  let resp = await fetch("http://localhost:4000/api/v1/comments", {
    method: "POST",
    body: data,
  })
  return await resp.json();
}

export async function delete_comment(id, wellness_id) {
  let data = new FormData();
  data.append("id", id);
  fetch("http://localhost:4000/api/v1/comments/" + id, {
    method: 'DELETE',
    body: data,
  }).then((resp) => {
    if(!resp.ok){
      let action = {
        type: 'error/set',
        data: 'Unable to delete event.',
      };
      store.dispatch(action);
    }else {
      console.log(wellness_id)
      fetch_comments(wellness_id);
      fetch_wellness()
    }
  });
}

//--------------------------Forum Comment -----------------------
export function fetch_forumcomments(forum_id) {
  api_get("/forumcomments").then((data) => {
    let result = []
    for (let [key, value] of Object.entries(data)) {
      console.log(value)
      console.log(forum_id)
      if (value.forum_id == forum_id) {
        result.push(value)
      }
    }
    store.dispatch({
    type: 'forumcomments/set',
    data: result,
  })})
}

export async function create_forumcomment(forumcomment, user_id, forum_id) {
  let data = new FormData();
  data.append("forumcomment[body]", forumcomment);
  data.append("forumcomment[forum_id]", forum_id);
  data.append("forumcomment[user_id]", user_id);
  let resp = await fetch("http://localhost:4000/api/v1/forumcomments", {
    method: "POST",
    body: data,
  })
  return await resp.json();
}

export async function delete_forumcomment(id, forum_id) {
  let data = new FormData();
  data.append("id", id);
  fetch("http://localhost:4000/api/v1/forumcomments/" + id, {
    method: 'DELETE',
    body: data,
  }).then((resp) => {
    if(!resp.ok){
      let action = {
        type: 'error/set',
        data: 'Unable to delete event.',
      };
      store.dispatch(action);
    }else {
      console.log(forum_id)
      fetch_forumcomments(forum_id);
      fetch_forums()
    }
  });
}

//---------------------user--------------------------------------
export function fetch_users() {
    api_get("/users").then((data) => store.dispatch({
        type: 'users/set',
        data: data,
    }));
}

export function fetch_user(id) {
  api_get("/users/" + id).then((data) => store.dispatch({
      type: 'user_form/set',
      data: data,
  }));
}

export async function create_user(user) {
  let data = new FormData();
  data.append("user[name]", user.name);
  data.append("user[email]", user.email);
  data.append("user[password]", user.password);
  data.append("user[reason]", user.reason);
  if (user.photo === "undefined") {
    user["photo"] = "";
  }
  data.append("user[photo]", user.photo);
  let resp = await fetch("http://localhost:4000/api/v1/users", {
    method: "POST",
    body: data,
  })
return await resp.json();
}

export async function update_user(user) {
  let data = new FormData();
  data.append("user_id", user.id);
  data.append("user[name]", user.name);
  data.append("user[email]", user.email);
  data.append("user[password]", user.password);
  data.append("user[reason]", user.reason);
  data.append("user[photo]", user.photo);
  let resp = await fetch("http://localhost:4000/api/v1/users/" + user.id, {
    method: "PATCH",
    body: data,
  })
return await resp.json();
}
//---------------------wellness page-----------------------------------
export function fetch_wellness() {
  api_get("/healths").then((data) => {
  data = sortWellness(data)
  store.dispatch({
    type: 'wellness/set',
    data: data,
  })});
}


export function fetch_single_wellness(id) {
  api_get("/healths/"+id).then((data) => store.dispatch({
    type: 'wellness_form/set',
    data: data,
  }));
}

export async function create_wellness(post) {
  let data = new FormData();
  data.append("health[user_id]", post.user_id);
  data.append("health[title]", post.title);
  data.append("health[body]", post.body);
  data.append("health[votes]", JSON.stringify([]))
  if (post.photo === "undefined") {
    post["photo"] = "";
  }
  data.append("health[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/healths", {
    method: "POST",
    body: data,
  })
return await resp.json();
}

export async function update_wellness(post) {
  let data = new FormData();
  data.append("health[user_id]", post.user_id);
  data.append("health[title]", post.title);
  data.append("health[body]", post.body);
  data.append("health[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/healths/" + post.id, {
    method: "PATCH",
    body: data,
  })
return await resp.json();
}

export async function delete_wellness(id) {
  let data = new FormData();
  data.append("id", id);
  fetch("http://localhost:4000/api/v1/healths/" + id, {
    method: 'DELETE',
    body: data,
  }).then((resp) => {
    if(!resp.ok){
      let action = {
        type: 'error/set',
        data: 'Unable to delete event.',
      };
      store.dispatch(action);
    }else {
      fetch_wellness();
    }
  });
}

export async function update_wellness_vote(post, user_id, action) {
  let data = new FormData();
  data.append("health[user_id]", post.user_id);
  data.append("health[title]", post.title);
  data.append("health[body]", post.body);
  let votes = post.votes
  if (action == "increase") {
    votes.push(user_id)
  }
  else {
    votes = votes.filter(function(e) { return e != user_id })
  }
  data.append("health[votes]", JSON.stringify(votes))
  if (post.photo === "undefined") {
    post["photo"] = "";
  }
  data.append("health[photo]", post.photo);
  let resp = await fetch("http://localhost:4000/api/v1/healths/" + post.id, {
    method: "PATCH",
    body: data,
  })
return await resp.json();
}

export function fetch_score(id) {
  api_get("/healths/"+id).then((data) => {
  store.dispatch({
    type: 'score/set',
    data: data.votes.length,
  })});
}

export function search_wellness(search) {
  api_get("/healths").then((data) => {
  data = sortWellness(data)
  data = handle_wellness_search(search, data)
  store.dispatch({
    type: 'wellness/set',
    data: data,
  })});
}

function handle_wellness_search(search, data) {
  if (search == "") {
    data = sortWellness(data)
    return data
  }
  else {
    let result = []
    for (let [key, value] of Object.entries(data)) {
      if (value.title.includes(search) || value.body.includes(search)) {
        result.push(value)
      }
    }
    result = sortWellness(result)
    return result
  }
}

function sortWellness(data) {
  return data.sort(function(a, b){
    return b.votes.length - a.votes.length});
}

//---------------------------login------------------------------------
export function api_login(email, password) {
  api_post("/session", {email, password}).then((data) => {
    if (data.session) {
      let action = {
        type: 'session/set',
        data: data.session,
      }
      store.dispatch(action);
    }
    else if (data.error) {
     let action = {
        type: 'error/set',
        data: data.error,
      }
      store.dispatch(action);
    }
  });
}

export function fetch_reason(reason) {
  switch(reason){
    case "Cat Wellness":
      return "/wellness/list"
      break;
    case "Breeder/Adoption":
      return "/selladopt"
      break;
    case "Lost/Found Cats":
      return "/lostfound"
      break;
    case "Food Choices/Recommendations":
      return "/food"
      break;
    case "Other":
      return "/forum"
      break;
    default:
      return "/"
    }
}
export function load_defaults() {
  fetch_users();
  fetch_wellness();
  fetch_forums();
}
