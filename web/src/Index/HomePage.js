import { Card, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { Link, useHistory, NavLink } from 'react-router-dom';
import pick from 'lodash/pick';
import store from '../store';
import { api_login, fetch_reason, fetch_user } from '../api';

function HomePage({wellness, forums}) {
  function ShowingWellness() {
    if (wellness.length > 3) {
      wellness = wellness.slice(0, 3)
    }
    let rows = wellness.map((health) => {
      let body = health.body.substring(0, 100) + " ..."
      const link = "/wellness/view/"+ health.id
      let score = health.votes.length
      return (
        <Card fluid>
          <Card.Header>{health.title}</Card.Header>
          <Card.Body>
            <p>{body}</p>
            <Link to={link}  className="text-danger">Read More</Link>
          </Card.Body>
        </Card>
    )});
    return <div>{rows}</div>
  }

  function ShowingForum() {
    if (forums.length > 3) {
      forums = forums.slice(0, 3)
    }
    let rows = forums.map((forum) => {
      let body = forum.body.substring(0, 100) + " ..."
      const link = "/forum/view/"+ forum.id
      let score = forum.votes.length
      return (
        <Card fluid>
          <Card.Header>{forum.title}</Card.Header>
          <Card.Body>
            <p>{body}</p>
            <Link to={link}  className="text-danger">Read More</Link>
          </Card.Body>
        </Card>
    )});
    return <div>{rows}</div>
  }


  return (
    <div>
      <h1 className="mt-2">About Kitten Lover</h1>
      <p className="h4">KittenLover is dedicated to provide support and a communicating
      platform to those who love their cats or for those we are about to get a cat/kitten</p>
      <div className="border">
        <h1 className="ml-2">Wellness</h1>
        <ShowingWellness />
      </div>
      <div className="border mt-5">
        <h1 className="ml-2">Forum</h1>
        <ShowingForum />
      </div>

    </div>
  );
}

function state2props({wellness, forums}) {
  return {wellness, forums};
}

export default connect(state2props)(HomePage);
