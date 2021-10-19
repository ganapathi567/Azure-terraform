var cfg = { _id: 'sts-mongos-svr',
    members: [
        { _id: 0, host: 'mongos-svr1.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 1, host: 'mongos-svr2.ppe.sts.eun.azure.tesco.org:27017'},
        { _id: 2, host: 'mongos-svr3.ppe.sts.eun.azure.tesco.org:27017'}
    ]
};
var error = rs.initiate(cfg);
printjson(error);

