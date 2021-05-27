import { useHistory } from "react-router-dom";
import { useSnackbar } from 'react-simple-snackbar'
import React, {useState } from "react";
import useFetch from 'use-http';

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

export default function CardAddShipment() {
    const {post, response} = useFetch('http://localhost:8080/shipment/add');
    const {push} = useHistory();
    const [openSucces] = useSnackbar(succesOptions);
    const [openError] = useSnackbar(errorOptions);
    const [form, setForm] = useState({
        id: '',
    });

    function updateField(e){
        setForm({
            ...form,
            [e.target.name]: e.target.value
        });
    }

    async function PostShipment(e){
        e.preventDefault();
        await post(form);
        if (response.ok){
            openSucces("Shipment accepted succesfully!");
            push("/admin/shipment/" + form.id);
        }
        if (!response.ok){
            openError("Failed to add Shipment: " + response.status + " (" + response.statusText + ")!");
        }
    }

  return (
    <div className="relative flex flex-col break-words bg-white mb-6 shadow-lg rounded">
        <div className="rounded-t px-4 py-3">
          <h2 className="text-blueGray-700 text-xl font-semibold">
            Add Shipment
          </h2>
        </div>
        <div className="p-4">
            <form onSubmit={PostShipment}>
                <div className="py-2">
                    <p className="font-medium">Shipment ID:</p>
                    <input value={form.id} name="id" onChange={updateField} type="text" placeholder="shipment ID" className="border" />
                </div>
                <div className="py-2">
                    <button type="submit" className="bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded">
                        Add Shipment
                    </button>
                </div>
            </form>
        </div>
    </div>
  );
}