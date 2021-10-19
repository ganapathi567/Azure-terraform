var cfg = { _id: 'sts-mongo-config',
    members: [
        { _id: 0, host: 'mongo-cfg1.zone.sts.dev.eun.azure.tesco.org:27017'},
        { _id: 1, host: 'mongo-cfg2.zone.sts.dev.eun.azure.tesco.org:27017'},
        { _id: 2, host: 'mongo-cfg3.zone.sts.dev.eun.azure.tesco.org:27017'}
    ]
};
var error = rs.initiate(cfg);
printjson(error);
