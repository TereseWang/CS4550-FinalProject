import { Button, Nav, NavRow, Row, Col, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link, useHistory, useLocation, NavLink } from 'react-router-dom';
import { useState } from 'react';
import { fetch_food_like, fetch_food_dislike, delete_food, fetch_foods, fetch_food, fetch_user, update_food_vote} from '../api';
import store from '../store';

function FoodView({session, food_form, user_form, food_like, food_dislike}) {
  let location = useLocation()
  let history = useHistory()
  let food_id = location.pathname.split("/food/view/")[1]

  if(typeof(food_form.id) == "undefined" || food_form.id != food_id) {
    fetch_foods()
    fetch_food(food_id)
    fetch_food_like(food_id)
    fetch_food_dislike(food_id)
  }

  if(typeof(user_form.id) == "undefined" || user_form.id != food_form.user_id){
    fetch_foods()
    fetch_user(food_form.user_id)
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function deleteForum(){
    delete_food(food_id)
    fetch_foods()
    history.push("/food/list")
  }

  function AddButtons() {
    if(session && session.user_id == user_form.id) {
      let link = "/food/edit/" + food_form.id
      return(
        <div>
        <Link to={link} className="btn mt-2 btn-lg btn-info text-light mr-2 font-weight-bold">Edit</Link>
        <Button onClick={deleteForum} className="btn mt-2 btn-lg btn-danger text-light mr-2 font-weight-bold">Delete</Button>
        <Link to="/food/list" className="btn btn-lg mt-2 btn-info text-light  font-weight-bold">Back</Link>
        </div>
      )
    }
    else {
      return(
        <Link to="/food/list" className="btn btn-lg mt-2 btn-danger text-light  font-weight-bold">Back</Link>
      )
    }
  }

  let link = photo_path(food_form.photo_hash)

  function updateVotes(field) {
    if(field == "like" && food_form.like.includes(session.user_id)) {
      update_food_vote(food_form, session.user_id, "decreaselike")
      fetch_foods()
      fetch_food(food_form.id)
      fetch_food_like(food_form.id)
      fetch_food_dislike(food_form.id)
    }
    else if(field == "dislike" && food_form.dislike.includes(session.user_id)) {
      update_food_vote(food_form, session.user_id, "decreasedislike")
      fetch_foods()
      fetch_food(food_form.id)
      fetch_food_like(food_form.id)
      fetch_food_dislike(food_form.id)
    }
    else if(field == "like" && !food_form.like.includes(session.user_id))  {
      update_food_vote(food_form, session.user_id, "increaselike")
      fetch_foods()
      fetch_food(food_form.id)
      fetch_food_like(food_form.id)
      fetch_food_dislike(food_form.id)
    }
    else {
      update_food_vote(food_form, session.user_id, "increasedislike")
      fetch_foods()
      fetch_food(food_form.id)
      fetch_food_like(food_form.id)
      fetch_food_dislike(food_form.id)
    }
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

    if (session) {
      return(
        <div>
          <AddButtons/>
          <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
          <div class="row">
            <div class="col">
              <img src={link} width="500px" height="400px"></img>
            </div>
            <div class="col">
              <h1 className="display-3">{food_form.brand}</h1>
              <h1 className="h3">Price</h1>
              <p className="h5 mt-2 text-danger">{food_form.price}$ per Lbs</p>
              <h1 className="h3">Type</h1>
              <p className="h5 mt-2 text-secondary">{food_form.type}</p>
              <h1 className="h3">Description</h1>
              <p className="h5 mt-2 text-secondary">{food_form.body}</p>
              <Button className="btn btn-lg btn-light text-danger" onClick={(field) => updateVotes("like")}>{food_like} 💗 Like</Button>
              <Button className="btn btn-lg btn-light text-danger" onClick={(field) => updateVotes("dislike")}>{food_dislike} 💔 Dislike</Button>
            </div>
          </div>
        </div>
      )
    }
    else {
      return(
        <div>
          <AddButtons/>
          <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
          <div class="row">
            <div class="col">
              <img src={link} width="500px" height="400px"></img>
            </div>
            <div class="col">
              <h1 className="display-3">{food_form.brand}</h1>
              <h1 className="h3">Price</h1>
              <p className="h5 mt-2 text-danger">{food_form.price}$ per Lbs</p>
              <h1 className="h3">Type</h1>
              <p className="h5 mt-2 text-secondary">{food_form.type}</p>
              <h1 className="h3">Description</h1>
              <p className="h5 mt-2 text-secondary">{food_form.body}</p>
              <h3 className="text-danger">{food_like} 💗 Like</h3>
              <h3 className="text-danger">{food_dislike} 💔 Dislike</h3>
            </div>
          </div>
        </div>
      )
    }
  }

function state2props({session, food_form, user_form, food_like, food_dislike}) {
  return {session, food_form, user_form, food_like, food_dislike};
}

export default connect(state2props)(FoodView);
