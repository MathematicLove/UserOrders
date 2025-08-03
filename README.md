# User&Orders
Stack used: 
- Language for back:
  - Ruby
- Framework for API:
  - Ruby on Rails
- DB:
  - PostgreSQL 
- UI:
  - Vue.js
- DeployTools:
  - Dockerfile 
  - CI for Rails with GitFlows (failed 😭)

## To run $_{on  \space macOS}$:
Starting server on localhost:3000 with Rails API: 
```zsh
cd user_order_api
rails s 
```

Running UI with Vue.js on localhost 
```zsh
cd ../vue-ui/npm install  
npm run dev  
```

To see all DB tables of users and they orders run:

```zsh
psql -U uname -d pt
```

Then run query: (Must create pt DB with tables: users and orders)
```SQL
SELECT users.username, orders.order_name, orders.amount, orders.order_date
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id;
```
