import {useState} from 'react';
import {useSnackbar} from 'react-simple-snackbar';
import useFetch from 'use-http';
import {useParams} from "react-router-dom";

const succesOptions = {
    position: 'top-right',
    style: {
        backgroundColor: "rgba(16, 185, 129)",
        border: '1px solid black',
        fontSize: '17px',
    }
};

const errorOptions = {
    position: 'top-right',
    style: {
        backgroundColor: "rgba(220, 38, 38)",
        border: '1px solid black',
        fontSize: '17px',
    }
};

/** 
 * Hook to handle add shipment methods.
 */
export default function useAddShipment(addSensor) {
    const {id} = useParams();
    const {post, response} = useFetch('/shipment/sensor/add');
    const [openSucces] = useSnackbar(succesOptions);
    const [openError] = useSnackbar(errorOptions);
    const [form, setForm] = useState({
        id: id,
        sensorID: '',
    });

    /** 
     * Update value on change.
     */
    function onChange(e){
        setForm({
            ...form,
            [e.target.name]: e.target.value
        });
    }

    /** 
     * Add new Sensor.
     */
    async function onSubmit(e) {
        e.preventDefault();

        await post(form);

        if (response.ok) {
            addSensor(form.sensorID);
            openSucces("Sensor added succesfully!");
            setForm({
                id: id,
                sensorID: '',
            });
        }
        if (!response.ok) openError("Failed to add Sensor: " + response.status + " (" + response.statusText + ")!");
        if (response.ok === undefined) openError("Failed to add Sensor: something went wrong while adding the sensor!");
    }

    return {
        form,
        onChange,
        onSubmit,
    }
}