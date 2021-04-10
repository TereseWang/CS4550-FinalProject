import { Nav, NavRow, Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory, NavLink, useLocation  } from 'react-router-dom';
import pick from 'lodash/pick';
import store from '../store';
import { update_wellness , fetch_wellness, fetch_user, fetch_single_wellness } from '../api';

function WellnessEdit({user_form, session, wellness_form}) {
  let location = useLocation()
  let wellness_id = location.pathname.split("/wellness/edit/")[1]
  if(typeof(wellness_form.id) == "undefined" || wellness_form.id != wellness_id) {
    fetch_single_wellness(wellness_id)
  }
  if(typeof(user_form.id) == "undefined" || user_form.id != wellness_form.user_id) {
    fetch_user(wellness_form.user_id)
  }

  let history = useHistory();
  const [post, setPost] = useState({
    user_id: user_form.id, body: wellness_form.body, title: wellness_form.title, id: wellness_form.id,
    votes: wellness_form.votes
  });

  function onSubmit(ev) {
    ev.preventDefault();
    let data = pick(post, ['user_id', 'title', 'body', 'photo', 'id']);
    update_wellness(data).then((data) => {
        if(data.error) {
          let action={
            type:"error/set",
            data: data.error
          }
          store.dispatch(action)
        }
        else {
          fetch_wellness()
          fetch_single_wellness(wellness_form.id)
          let link = "/wellness/view/" + wellness_form.id
          history.push(link)
        }
    });
  }

  function update(field, ev) {
    let u1 = Object.assign({}, post);
    u1[field] = ev.target.value;
    setPost(u1);
  }

  function updatePhoto(ev) {
    let p1 = Object.assign({}, post);
    p1["photo"] = ev.target.files[0];
    setPost(p1);
  }

  function Redirect({to, children}) {
    return (
      <Nav.Item>
        <NavLink to={to} exact
          className="btn font-weight-bold text-light btn-danger"
          activeClassName="active">
          {children}
        </NavLink>
      </Nav.Item>
    );
  }
  let link = "/wellness/view/" + wellness_form.id

  if(session) {
    return(
        <Form onSubmit={onSubmit}>
          <Form.Group>
            <h1 className="mt-5">Edit Wellness Post</h1>
            <Form.Label>Post Title</Form.Label>
            <Form.Control type="text"
                          onChange={
                            (ev) => update("title", ev)}
              value={post.title} />
          </Form.Group>
          <Form.Group>
          <Form.Label>Post Body</Form.Label>
          <Form.Control as="textarea"
                        onChange={
                          (ev) => update("body", ev)}
            value={post.body} />
        </Form.Group>
        <Form.Group>
              <Form.Label>Profile Picture</Form.Label>
              <Form.Control type="file" onChange={updatePhoto} />
        </Form.Group>
          <Row className="ml-1">
          <Button variant="primary" type="submit" className="h3 font-weight-bold mr-3">
            Save
          </Button>
          <Redirect to={link}>Cancel</Redirect>
          </Row>
        </Form>
      );
  }
  else{
    return <h1 className="mt-5 ml-5">Please Login In To Edit</h1>
  }
}

function state2props({user_form, session, wellness_form}) {
  return {user_form, session, wellness_form};
}

export default connect(state2props)(WellnessEdit);
