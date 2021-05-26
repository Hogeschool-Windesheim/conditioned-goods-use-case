import React, {useState } from "react";
import useFetch from 'use-http';


export default function CardAddShipment() {
    const [form, setState] = useState({
        id: '',
    });
    const [buttonText, setButton] = useState("Add Shipment");
    const [buttonClass, setButtonClass] = useState("bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded")
    const {post, response} = useFetch('http://localhost:8080/shipment/add');

    function updateField(e){
        const value = e.target.value;
        setState({
            ...form,
            [e.target.name]: value
        });
        setButton("Add Shipment");
        setButtonClass("bg-lightBlue-600 hover:bg-lightBlue-800 text-white font-bold py-2 px-4 rounded");
    }

    function PostShipment(e){
        e.preventDefault();
        setButton("loading...");
        setButtonClass("bg-yellow-500 text-white font-bold py-2 px-4 rounded");
        console.log(form)
        post(form).then( 
            setTimeout(() => {
                if (response.ok === true){
                    setButton("succes");
                    setButtonClass("bg-green-500 text-white font-bold py-2 px-4 rounded");
                    setTimeout(() => {
                    window.location.href = "http://localhost:3000/admin/dashboard"
                    }, 1000);
                    console.log(response);
                }
                if (response.ok === false){
                    setButton("Error " + response.status + " (" + response.statusText +")");
                    setButtonClass("bg-red-600 text-white font-bold py-2 px-4 rounded");
                    console.log(response);
                }
            }, 1000),
        );
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
                    <button type="submit" className={buttonClass}>
                        {buttonText}
                    </button>
                </div>
            </form>
        </div>
    </div>
  );
}