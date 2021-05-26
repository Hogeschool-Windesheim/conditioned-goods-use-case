import React, {useState } from "react";
import useFetch from 'use-http';

export default function CardAddShipment() {
    const [form, setForm] = useState({
        id: '',
    });
    const [buttonText] = useState({
        idle: "Add Shipment",
        load: "loading...",
        error: "Error ",
        succes: "succes"
    });
    const [buttonClass] = useState({
        idle: "bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded",
        load: "bg-yellow-500 text-white font-bold py-2 px-4 rounded",
        error: "bg-red-600 text-white font-bold py-2 px-4 rounded",
        succes: "bg-green-500 text-white font-bold py-2 px-4 rounded"
    });
    const [buttonState, SetButtonState] = useState({
        text: buttonText.idle,
        class: buttonClass.idle
    });
    const {post, response} = useFetch('http://localhost:8080/shipment/add');

    function updateField(e){
        setForm({
            ...form,
            [e.target.name]: e.target.value
        });
        SetButtonState({text:buttonText.idle, class:buttonClass.idle});
    }

    async function PostShipment(e){
        SetButtonState({text:buttonText.load, class:buttonClass.load});
        e.preventDefault();
        await post(form).then(() => {
            if (response.ok === true){
                SetButtonState({text:buttonText.succes, class:buttonClass.succes});
                // window.location.href = "http://localhost:3000/admin/shipment/" + form.id;
            }
            if (response.ok === false){
                SetButtonState({text:buttonText.error + response.status + " (" + response.statusText +")", class: buttonClass.error});
            }
        });
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
                    <button type="submit" className={buttonState.class}>
                        {buttonState.text}
                    </button>
                </div>
            </form>
        </div>
    </div>
  );
}