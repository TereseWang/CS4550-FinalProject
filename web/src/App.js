import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import './App.scss';
import Nav from './Nav';
import LoginForm from './Nav';
import UsersNew from "./User/New"

function App() {
  return (
    <div>
      <Container fluid className="bg">
        <Nav />
        <Switch>
        </Switch>
      </Container>
      <Container>
      <Route path="/" exact>
        <h2>Home Page</h2>
      </Route>
      <Route path="/wellness">
      </Route>
      <Route path="/lostfound">
      </Route>
      <Route path="/food">
      </Route>
      <Route path="/selladopt">
      </Route>
      <Route path="/forum">
      </Route>
        <Route path="/users/new">
          <UsersNew />
        </Route>
      </Container>
    </div>
  );
}

export default App;
