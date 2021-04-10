import { Nav, NavRow, Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory, NavLink  } from 'react-router-dom';
import pick from 'lodash/pick';
import store from '../store';
import { create_wellness , fetch_wellness, fetch_users } from '../api';

function UserForm({session}) {
  let history = useHistory();
  const [post, setPost] = useState({
    user_id: session.user_id, body: "", title: ""
  });

  function onSubmit(ev) {
    ev.preventDefault();
    let data = pick(post, ['user_id', 'title', 'body', 'photo']);
    create_wellness(data).then((data) => {
        if(data.error) {
          let action={
            type:"error/set",
            data: data.error
          }
          store.dispatch(action)
        }
        else {
          fetch_wellness()
          fetch_users()
          history.push("/Wellness/list")
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

  return(
      <Form onSubmit={onSubmit}>
        <Form.Group>
          <h1 className="mt-5">Create Wellness Post</h1>
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
        <Redirect to="/wellness/list">Cancel</Redirect>
        </Row>
      </Form>
    );
  }

function LoginEdit({session}) {
  if(session) {
    return <UserForm session={session}/>
  }
  else{
    return <h1 className="mt-5 ml-5">Please Login In To Edit</h1>
  }
}

const UpdateUserForm = connect(
    ({session}) => ({session}))(LoginEdit);

function WellnessNew() {
  return (
    <UpdateUserForm/>
  );
}

function state2props(_state) {
  return {};
}

export default connect(state2props)(WellnessNew);
