import {useState} from 'react';
import {useSnackbar} from 'react-simple-snackbar';
import useFetch from 'use-http';
import {useHistory} from "react-router-dom";
import {succesOptions, errorOptions} from 'libs/snackbar.js';

/** 
 * Hook to handle add shipment methods.
 */
export default function useAddShipment() {
    const {post, loading, response} = useFetch('/shipment/add');
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

        if (loading && response.ok) {
            openSucces("Shipment accepted succesfully!");
            push("/admin/shipment/" + form.id);
        }

        if (!loading && (!response.ok || response.ok === undefined)) {
            let error = response.data?.error.split("Error:")[1] || "Something went wrong while adding the shipment";
            openError(error);
        }
    }

    return {
        form,
        onChange,
        createShipment
    }
}