import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import './App.scss';
import Nav from './Nav';
import UsersNew from "./User/New";
import UsersView from "./User/View";
import UsersEdit from "./User/Edit";
import WellnessList from "./Wellness/List";
import WellnessNew from "./Wellness/New";
import WellnessView from "./Wellness/View";
import WellnessEdit from "./Wellness/Edit";
import HomePage from "./Index/HomePage";

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
        <HomePage/>
      </Route>
      <Route path="/wellness/list">
        <WellnessList/>
      </Route>
      <Route path="/wellness/new">
        <WellnessNew />
      </Route>
      <Route path="/wellness/edit">
        <WellnessEdit />
      </Route>
      <Route path="/wellness/view">
        <WellnessView/>
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
        <Route path="/users/view">
          <UsersView />
        </Route>
        <Route path="/users/edit">
          <UsersEdit />
        </Route>
      </Container>
    </div>
  );
}

export default App;
