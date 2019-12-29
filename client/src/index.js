import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import React from 'react';
import { render } from 'react-dom';
import { ApolloProvider } from '@apollo/react-hooks';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import 'react-tabs/style/react-tabs.css';

const cache = new InMemoryCache();
const link = new HttpLink({
  uri: 'http://localhost:4000/'
});

const client = new ApolloClient({
  cache,
  link
});


const App = () => (
<Tabs>
  <TabList>
     <Tab>Tab 1</Tab>
     <Tab>Tab 2</Tab>
  </TabList>
  <TabPanel>
     <ApolloProvider client={client}>
     <div>
        <h2>My first Apollo app 🚀</h2>
     </div>
     </ApolloProvider>
  </TabPanel>
  <TabPanel>
  </TabPanel>
</Tabs>
);

render(<App />, document.getElementById('root'));
