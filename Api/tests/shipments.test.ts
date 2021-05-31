import supertest from 'supertest';
import {app} from '../src/index';

describe('Shipment controller', () =>  {
    const request = supertest(app);

    describe("Get shipments", () => {
        it("/shipments", async () => {
            const expected = {
                id: '1',
                sensors: [],
            };

            await request.post('/shipment/add')
                .send({
                    id: '1'
                });

            const {body} = await request
                .get('/shipments')
                .expect(200);

            expect(body.result).toEqual(
                expect.arrayContaining([expect.objectContaining(expected)])
            );
        });

        it("/shipments/1", async () => {
            await request.post('/shipment/add')
                .send({
                    id: '2'
                });

            const {body} = await request
                .get('/shipments/1')
                .expect(200);

            expect(body.result.length).toEqual(1);
        });
    });

    describe("Get shipment", () => {
        it("/shipment/3", async () => {
            const expected = {
                id: '3',
                sensors: [],
            };

            await request.post('/shipment/add')
                .send({
                    id: '3'
                });

            const {body} = await request
                .get('/shipment/3')
                .expect(200);

            expect(body).toMatchObject(expected);
        });
    });

    describe("Add shipment", () => {
        it("/shipment/add", async () => {
            const expected = {
                id: '4',
                sensors: [],
            };

            const {body} = await request
                .post('/shipment/add')
                .send({
                    id: '4'
                })
                .expect(200);

            expect(body).toMatchObject(expected);
        });
    });

    describe("Shipment exist", () => {
        it("/shipment/5/exist", async () => {
            await request.post('/shipment/add')
                .send({
                    id: '5'
                });

            const {body} = await request
                .get('/shipment/5/exist')
                .expect(200);

            expect(body).toEqual(true);
        });

        it("/shipment/6/exist", async () => {
            const {body} = await request
                .get('/shipment/6/exist')
                .expect(200);

            expect(body).toEqual(false);
        });
    });

    describe("Shipment register sensor", () => {
         it("/shipment/sensor/add", async () => {

            await request.post('/shipment/add')
                .send({
                    id: '7'
                });

            const {body} = await request.post('/shipment/sensor/add')
                .send({
                    id: "7",
                    sensorID: "1"
                })
                .expect(200);

            expect(body).toEqual('1');
        });
    });

     describe("Shipment has sensor", () => {
         it("/shipment/8/sensor/1", async () => {
            await request.post('/shipment/add')
                .send({
                    id: '8'
                });

            await request.post('/shipment/sensor/add')
                .send({
                    id: "8",
                    sensorID: "1"
                });

            const {body} = await request.get('/shipment/8/sensor/1')
                .expect(200);

            expect(body).toEqual(true);
        });

        it("/shipment/8/sensor/2", async () => {
            const {body} = await request.get('/shipment/8/sensor/2')
                .expect(200);

            expect(body).toEqual(false);
        });
    });
});