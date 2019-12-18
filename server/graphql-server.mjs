// nodejs does not have named exports
import apolloServer from 'apollo-server';
const { ApolloServer, gql } = apolloServer;

// Construct a schema, using GraphQL schema language
const typeDefs = gql`
  type Query {
    hello: String
    uploads: [File]	
  }

  type File {
    filename: String!
    mimetype: String!
    encoding: String!
  }

  type Mutation {
    singleUpload(file: Upload!): File!
  }  
`;

// The root provides a resolver function for each API endpoint
const resolvers = {
Query: {
  hello: () => {return 'Hello world!'},
  uploads: () => {
     // Return the record of files uploaded from your DB or API or filesystem.
  }
},
Mutation: {
    async singleUpload(parent, { file }) {
      const { stream, filename, mimetype, encoding } = await file;

      // 1. Validate file metadata.

      // 2. Stream file contents into cloud storage:
      // https://nodejs.org/api/stream.html

      // 3. Record the file upload in your DB.
      // const id = await recordFile( … )

      return { filename, mimetype, encoding };
    }
}
};

const server = new ApolloServer({typeDefs, resolvers});
server.listen(4000, '0.0.0.0').then(({ url }) => {
  console.log(`🚀  Server ready at ${url}`);
});
