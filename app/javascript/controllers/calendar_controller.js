import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";

export default class extends Controller {
	connect() {
		this.loadCalendar();
	}

	loadCalendar() {
		let calendarEl = this.element;
		let calendar = new Calendar(calendarEl, {
			plugins: [dayGridPlugin, timeGridPlugin],
			initialView: 'dayGridMonth',
			headerToolbar: {
				left: 'prev,next today',
				center: 'title',
				right: 'dayGridMonth,timeGridWeek,timeGridDay'
			},
			eventClick: function(info) {
				if (info.event && info.event._def.publicId) {
					const eventId = info.event._def.publicId;
					window.location.href = `/events/${eventId}`;
				}
			},
	    selectable: true, // Allow selecting date range
	    events: (info, successCallback, failureCallback) => this.loadEvents(info, successCallback, failureCallback)
	  });
		calendar.render();

		console.log("calendar++")

		calendarEl.addEventListener('click', async (ev) => {
	  const clickedDate = calendar.getDate(); // Get the current date displayed on the calendar

	  if (clickedDate) {
	    const formattedDate = clickedDate.toISOString().split('T')[0]; // Format the clicked date

	    const today = new Date().toISOString().split('T')[0];
	    if (formattedDate < today) {
	    	alert('Cannot create events in the past!');
	    	return;
	    }

	    const eventName = prompt('Enter Event Name:');
	    const eventType = prompt('Enter Event Type:');
	    const eventStartDate = prompt('Enter Start Date (YYYY-MM-DD):');
	    const eventStartTime = prompt('Enter Start Time (HH:MM):');
	    const eventEndDate = prompt('Enter End Date (YYYY-MM-DD):');
	    const eventEndTime = prompt('Enter End Time (HH:MM):');
	    const eventDescription = prompt('Enter Event Description:');

	    // Prepare the event data to send to the server
	    const eventData = {
	    	event_name: eventName,
	    	event_type: eventType,
	    	start_date: eventStartDate,
	    	end_date: eventEndDate,
	    	start_time: eventStartTime,
	    	end_time: eventEndTime,
	    	description: eventDescription
	    };

	    try {
	    	const response = await fetch('/events', {
	    		method: 'POST',
	    		headers: {
	    			'Content-Type': 'application/json',
	    			'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
	    		},
	        body: JSON.stringify({ event: eventData }), // Sending event data in JSON format
	      });

	    	if (response.ok) {
	    		const createdEvent = await response.json();
	    		console.log('Event created:', createdEvent);
	        // You might add the created event to the calendar UI here
	    	} else {
	    		console.error('Failed to create event:', response.status);
	        // Handle the error response if needed
	    	}
	    } catch (error) {
	    	console.error('Error creating event:', error);
	      // Handle any network-related errors
	    }
	  }
	});
	}

	loadEvents(info, successCallback, failureCallback) {
		fetch("/events/calendar.json")
		.then((response) => {
			if (!response.ok) {
				throw new Error(`Network response was not ok. Status: ${response.status}`);
			}
			return response.json();
		})
		.then((data) => {
			successCallback(data);
		})
		.catch((error) => {
			console.error('Error fetching events:', error);
			failureCallback(error);
		});
	}
}
