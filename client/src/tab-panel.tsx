import React from 'react';
import Typography from '@material-ui/core/Typography';
import Box from '@material-ui/core/Box';

type TabPanelProps = {
  children: React.ReactNode,
  index: any,
  value: any
};

export default class TabPanel extends React.Component<TabPanelProps> {
    render() {
  const { children, value, index, ...other } = this.props;

  return (
    <Typography
      component="div"
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && <Box p={3}>{children}</Box>}
    </Typography>
  );
    }
}

