conn = new Mongo();
db = conn.getDB('admin');
db.createUser({user: '${user}', pwd: '${password}', roles: [{role: 'root', db: 'admin'}]});
db.auth('${user}', '${password}');
