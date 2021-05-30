// import {request} from 'supertest';
import supertest from 'supertest';
import {app} from '../src/index';

describe('Shipment controller', () =>  {
    const request = supertest.agent(app);

    describe("Get shipments", () => {
        it("/shipments", () => {
            const expected = {
                id: '1',
                sensors: [],
            };

            return request
                .get('/shipments')
                .expect(200)
                .then(({body}) => {
                    expect(body.result).toEqual(
                        expect.arrayContaining([expect.objectContaining(expected)])
                    );
                });
        });

        it("/shipments/1", () => {
            return request
                .get('/shipments/1')
                .expect(200)
                .then(({body}) => {
                    expect(body.result.length).toEqual(1);
                });
        });
    });

    describe("Get shipment", () => {
        it("/shipment/1", () => {
            const expected = {
                id: '1',
                sensors: [],
            };

            return request
                .get('/shipment/1')
                .expect(200)
                .then(({body}) => {
                    expect(body).toMatchObject(expected);
                });
        });
    });

    describe("Add shipment", () => {
        it("/shipment/add", () => {
            const expected = {
                id: '3',
                sensors: [],
            };

            return request
                .post('/shipment/add')
                .send({
                    id: '3'
                })
                .expect(200)
                .then(({body}) => {
                    expect(body).toMatchObject(expected);
                });
        });
    });

});