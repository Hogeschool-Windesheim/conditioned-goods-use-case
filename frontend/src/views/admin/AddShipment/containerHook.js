import {useState} from 'react';
import {useSnackbar} from 'react-simple-snackbar';
import useFetch from 'use-http';
import { useHistory } from "react-router-dom";

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
export default function useAddShipment() {
    const {post, response} = useFetch('http://localhost:8080/shipment/add');
    const {push} = useHistory();
    const [openSucces] = useSnackbar(succesOptions);
    const [openError] = useSnackbar(errorOptions);
    const [form, setForm] = useState({
        id: '',
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
     * Create new shipment.
     */
    async function createShipment(e) {
        e.preventDefault();

        await post(form);

        if (response.ok) {
            openSucces("Shipment accepted succesfully!");
            push("/admin/shipment/" + form.id);
        }
        if (!response.ok && response.status !== undefined && response.statusText !== undefined ) openError("Failed to add Shipment: " + response.status + " (" + response.statusText + ")!");
        if (!response.ok && response.status === undefined && response.statusText === undefined ) openError("Failed to add Shipment: see the console for more info!");
    }

    return {
        form,
        onChange,
        createShipment
    }
}