// Function to open the update form pop-up
function openUpdateForm(id, name, degree, mail, dob, gender) {
    document.getElementById("updateId").value = id;
    document.getElementById("updateName").value = name;
    document.getElementById("updateDegree").value = degree;
    document.getElementById("updateMail").value = mail;
    document.getElementById("updateDob").value = dob;
    document.getElementById("updateGender").value = gender;
    document.getElementById("updateForm").style.display = "block";
}

// Function to open the create form pop-up
function openCreateForm() {
    document.getElementById("createForm").style.display = "block";
}

// Function to close the pop-up form
function closeForm() {
    document.getElementById("updateForm").style.display = "none";
    document.getElementById("createForm").style.display = "none";
}