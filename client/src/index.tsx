import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import React from 'react';
import { render } from 'react-dom';
import { ApolloProvider } from '@apollo/react-hooks';

import { ThemeProvider, createMuiTheme } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import TabPanel from './tab-panel';
import Button from '@material-ui/core/Button';
import Emoji from './emoji';

const cache = new InMemoryCache();
const link = new HttpLink({
  uri: 'http://localhost:4000/'
});

const client = new ApolloClient({
  cache,
  link
});


function a11yProps(index : any) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

const useStyles = makeStyles(theme => ({
  root: {
    flexGrow: 1,
    textTransform: 'none',
    backgroundColor: theme.palette.background.paper,
  },
}));

const theme = createMuiTheme({
    overrides: {
	MuiTab: {
	    root: {
		textTransform: 'none'
	    },
	},
    }
});

export const SimpleTabs = (props: any) => {
  const classes = useStyles();
  const [value, setValue] = React.useState(0);

  const handleChange = (event : any, newValue : any) => {
    setValue(newValue);
  };

  return (
 <div className={classes.root}>
    <ThemeProvider theme={theme}>
      <AppBar position="static">
        <Tabs value={value} onChange={handleChange} aria-label="simple tabs example">
          <Tab label="Apollo item" {...a11yProps(0)} />
          <Tab label="Item Two" {...a11yProps(1)} />
          <Tab label="Item Three" {...a11yProps(2)} />
        </Tabs>
       </AppBar>
       <TabPanel value={value} index={0}>
           <ApolloProvider client={client}>
           <div>
              <h2>My first Apollo app <Emoji symbol="🚀"/></h2>
           </div>
           </ApolloProvider>
      </TabPanel>
      <TabPanel value={value} index={1}>
	  <Button variant="contained" color="primary">
	  Hello World
          </Button>
      </TabPanel>
      <TabPanel value={value} index={2}>
        Item Three
      </TabPanel>
    </ThemeProvider>
 </div>
  );
}

render(<SimpleTabs />, document.getElementById('root'));
