import { Nav, Navbar, Row, Col, Form, Button ,Container, Alert } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_login, fetch_user } from './api';
import { useHistory } from 'react-router-dom';

function photo_path(hash) {
  return "http://localhost:4000/photos/" + hash;
}

function LoginForm() {
  let history = useHistory();
  const [email, setName] = useState("");
  const [pass, setPass] = useState("");

  function on_submit(ev) {
    ev.preventDefault();
    api_login(email, pass);
    history.push("/");
  }

  return (
    <Form onSubmit={on_submit} inline>
      <Row>
        <Col>
          <div className="h5 font-weight-bold text-dark">Email:</div>
          <Form.Control name="email"
                        type="text"
                        onChange={(ev) => setName(ev.target.value)}
                        value={email}/>
        </Col>
      </Row>
      <Row className="ml-2 my-2">
        <Col>
          <div className="h5 font-weight-bold text-dark">Password:</div>
          <Form.Control name="password"
                        type="password"
                        onChange={(ev) => setPass(ev.target.value)}
                        value={pass}/>
          <Button className="h3 font-weight-bold ml-2 mr-2" type="submit">Logins </Button>
        </Col>
      </Row>
      <div className="mt-4">
        <Redirect to="/users/new">Register</Redirect>
      </div>
    </Form>
  );
}

let SessionInfo = connect()(({session, dispatch}) => {
  let history = useHistory();
  function logout() {
    dispatch({type: 'session/clear'});
    history.push("/");
  }
  return (
    <div className="h4 ml-1 font-weight-bold">
      <img src={photo_path(session.photo_hash)} className="mr-2" width="50px"></img>
      {session.email} &nbsp;
      <Button className="h3 ml-2 font-weight-bold" onClick={logout}>Logout</Button>
    </div>
  );
});

function LOI({session}) {
  if (session) {
    return <SessionInfo session={session} />;
  }
  else {
    return <LoginForm />;
  }
}

const LoginOrInfo = connect(
  ({session}) => ({session}))(LOI);

function Link({to, children}) {
  return (
    <Nav.Item>
      <NavLink to={to} exact
        className="nav-link font-weight-bold text-dark"
        activeClassName="active">
        {children}
      </NavLink>
    </Nav.Item>
  );
}

function Redirect({to, children}) {
  return (
    <Nav.Item>
      <NavLink to={to} exact
        className="btn btn-info font-weight-bold text-light"
        activeClassName="active">
        {children}
      </NavLink>
    </Nav.Item>
  );
}

function AppNav({error}) {
  let error_row = null;

  if (error) {
    console.log(error)
    error_row = (
      <Row>
        <Col>
          <Alert variant="danger">{error}</Alert>
        </Col>
      </Row>
    );
  }
  function Register({session}) {
      return(
        <Row>
          <Nav variant="tabs" defaultActiveKey="/users/new">
            <Link to="/">HomePage</Link>
            <Link to="/wellness">Wellness</Link>
            <Link to="/lostfound">Lost/Found</Link>
            <Link to="/food">Food Choices</Link>
            <Link to="/selladopt">Sell/Adopt</Link>
            <Link to="/forum">Forum</Link>
          </Nav>
      </Row>
    )
  }

  const LoginInRegister = connect(
    ({session}) => ({session}))(Register);

  return(
    <div>
      <h1 className="font-weight-bold text-info display-2">Kitten Lover</h1>
      { error_row }
      <LoginOrInfo />
      <LoginInRegister/>
    </div>
  );
}
export default connect(({error}) => ({error}))(AppNav);
