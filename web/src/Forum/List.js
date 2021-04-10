import { Button, Nav, NavRow, Row, Col, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { Link, useHistory, NavLink, useLocation } from 'react-router-dom';
import { fetch_user, fetch_forum, fetch_forums } from '../api';
import Carousel from 'react-bootstrap/Carousel';

function ForumList ({forums, session}) {
  let history = useHistory()
  let location = useLocation();

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function AddNewForumButton() {
    if (session) {
      return(
        <Redirect to="/forum/new" className="btn btn-lg font-weight-bold btn-info ml-3">
          New Forum
        </Redirect>
      )
    }
    else {
      return(
        <br></br>
      )
    }
  }

  function ListingArticles() {
    let rows = forums.map((health) => {
      let body = health.body.substring(0, 280) + " ..."
      const link = "/forum/view/"+ health.id
      let score = health.votes.length
      return (
        <Card fluid className="my-4">
          <Card.Header>{score} 💗</Card.Header>
          <Card.Body>
            <h1 className="">{health.title}</h1>
            <p>{body}</p>
            <Link to={link}  className="text-danger">Read More</Link>
          </Card.Body>
        </Card>
    )});

    return(
      <div className="ml-3">
        {rows}
      </div>
    )
  }

  function Redirect({to, children}) {
    return (
      <Nav.Item>
        <NavLink to={to} exact
          className="btn btn-lg font-weight-bold text-light btn-info"
          activeClassName="active">
          {children}
        </NavLink>
      </Nav.Item>
    );
  }

  function ImageGallery() {
    let query = forums
    if (forums.length >= 5) {
      query = Object.entries(forums).slice(0,5).map(entry => entry[1]);
    }
    let rows = query.map((health) => {
      let body = health.body.substring(0, 280) + " ..."
      let link = "/forum/view/" + health.id;
      return (
        <Carousel.Item>
          <img src={photo_path(health.photo_hash)} width="100%" height="600px"></img>
          <Carousel.Caption>
            <Link to={link}  className="text-info h3">Direct To Article: {health.title}</Link>
          </Carousel.Caption>
        </Carousel.Item>
    )});
    return(
      <Carousel className="my-3">
        {rows}
      </Carousel>
    )
  }

  return (
    <div>
      <p className="display-1">Forum</p>
      <ImageGallery />
      <Row>
        <Col>
          <AddNewForumButton />
        </Col>
      </Row>
      <ListingArticles />
    </div>
  );
}

function state2props({forums, session}) {
  return { forums, session};
}

export default connect(state2props)(ForumList);
