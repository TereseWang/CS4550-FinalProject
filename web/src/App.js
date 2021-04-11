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
import ForumList from "./Forum/List";
import ForumView from "./Forum/View";
import ForumNew from "./Forum/New";
import ForumEdit from "./Forum/Edit";
import FoodList from "./Food/List";
import FoodNew from "./Food/New";
import FoodEdit from "./Food/Edit";
import FoodView from "./Food/View";
import AdoptionList from "./Adoption/List";

//referenced from lecture code SPA Structure from Nat Tuck CS4550 Northeastern University
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
      <Route path="/adopt">
        <AdoptionList />
      </Route>
      <Route path="/food/list">
        <FoodList />
      </Route>
      <Route path="/food/new">
        <FoodNew />
      </Route>
      <Route path="/food/edit">
        <FoodEdit />
      </Route>
      <Route path="/food/view">
        <FoodView />
      </Route>
      <Route path="/wellness/list">
        <WellnessList />
      </Route>
      <Route path="/wellness/new">
        <WellnessNew />
      </Route>
      <Route path="/wellness/edit">
        <WellnessEdit />
      </Route>
      <Route path="/wellness/view">
        <WellnessView />
      </Route>
      <Route path="/forum/list">
        <ForumList />
      </Route>
      <Route path="/forum/view">
        <ForumView />
      </Route>
      <Route path="/forum/new">
        <ForumNew />
      </Route>
      <Route path="/forum/edit">
        <ForumEdit />
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
