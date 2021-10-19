var cfg = { _id: 'sts-mongo-shard-roi',
    members: [
        { _id: 0, host: 'mongo-shard-roi1.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 1, host: 'mongo-shard-roi2.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 2, host: 'mongo-shard-roi3.ppe.sts.eun.azure.tesco.org:27017'}
    ]
};
var error = rs.initiate(cfg);
printjson(error);
