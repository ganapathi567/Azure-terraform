var cfg = { _id: 'sts-mongo-shard-uk',
    members: [
        { _id: 0, host: 'mongo-shard-uk1.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 1, host: 'mongo-shard-uk2.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 2, host: 'mongo-shard-uk3.ppe.sts.eun.azure.tesco.org:27017'}
    ]
};
var error = rs.initiate(cfg);
printjson(error);
