package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	_ "github.com/denisenkom/go-mssqldb"
	"github.com/gorilla/mux"
)

const connectionString = "server=localhost;database=sw-web-service;"

type Passport struct {
	Type   string `json:"Type,omitempty"`
	Number string `json:"Number,omitempty"`
}

type Department struct {
	Name  string `json:"Name,omitempty"`
	Phone string `json:"Phone,omitempty"`
}

type Employee struct {
	Id         int    `json:"Id"`
	Name       string `json:"Name,omitempty"`
	Surname    string `json:"Surname,omitempty"`
	Phone      string `json:"Phone,omitempty"`
	CompanyId  int    `json:"CompanyId,omitempty"`
	Passport   Passport
	Department Department
}

// Add new employee to DB, return id
func createEmployee(w http.ResponseWriter, r *http.Request) {

	// Get employee from request
	employee := Employee{}
	var employeeID sql.NullInt64
	err := json.NewDecoder(r.Body).Decode(&employee)
	if err != nil {
		fmt.Fprint(w, err)
		return
	}

	// Open db connection
	db, err := sql.Open("sqlserver", connectionString)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

	// Execute sp
	_, err = db.Exec("spEmployee_Load",
		sql.Named("rintID", sql.Out{Dest: &employeeID}),
		sql.Named("vstrName", employee.Name),
		sql.Named("vstrSurname", employee.Surname),
		sql.Named("vstrPhone", employee.Phone),
		sql.Named("vintCompanyId", employee.CompanyId),
		sql.Named("vstrPassportType", employee.Passport.Type),
		sql.Named("vstrPassportNumber", employee.Passport.Number),
		sql.Named("vstrDepartmentName", employee.Department.Name),
		sql.Named("vstrDepartmentPhone", employee.Department.Phone),
	)
	if err != nil {
		fmt.Println(err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Set response status and headers
	w.WriteHeader(http.StatusCreated)
	w.Header().Set("Content-Type", "application/json")
	// Format for response
	outMap := map[string]int64{"Id": employeeID.Int64}

	json.NewEncoder(w).Encode(outMap)
}

// Delete employee from DB
func deleteEmployee(w http.ResponseWriter, r *http.Request) {

	// Get request parameters for searching employee id
	params := mux.Vars(r)

	// Open db connection
	db, err := sql.Open("sqlserver", connectionString)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

	// Execute sp
	_, err = db.Exec("spEmployee_Delete",
		sql.Named("vintID", params["Id"]),
	)
	if err != nil {
		fmt.Println(err)
		w.WriteHeader(http.StatusNotFound)
		return
	}

	// Set response status
	w.WriteHeader(http.StatusNoContent)
}

// Get list of employees of company
func getEmployeeByCompany(w http.ResponseWriter, r *http.Request) {

	// Get request parameters for searching company id
	params := mux.Vars(r)

	// Open db connection
	db, err := sql.Open("sqlserver", connectionString)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

	// Query to DB
	res, err := db.Query("spEmployee_List",
		sql.Named("vintCompanyId", params["Id"]),
	)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer res.Close()

	// Prepare DB result to response
	employees := []Employee{}
	for res.Next() {
		var employee Employee
		err = res.Scan(
			&employee.Id,
			&employee.Name,
			&employee.Surname,
			&employee.Phone,
			&employee.CompanyId,
			&employee.Passport.Type,
			&employee.Passport.Number,
			&employee.Department.Name,
			&employee.Department.Phone,
		)
		if err != nil {
			fmt.Println(err)
			return
		}
		employees = append(employees, employee)
	}

	// Set response headers
	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(employees)
}

// Get list of employees of department
func getEmployeeByDepartment(w http.ResponseWriter, r *http.Request) {

	// Get url parameters for searching department name
	urlparams := r.URL.Query()

	// Open db connection
	db, err := sql.Open("sqlserver", connectionString)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

	// Query to DB
	res, err := db.Query("spEmployee_List",
		sql.Named("vstrDepartmentName", urlparams.Get("name")),
	)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer res.Close()

	// Prepare DB result to response
	employees := []Employee{}
	for res.Next() {
		var employee Employee
		err = res.Scan(
			&employee.Id,
			&employee.Name,
			&employee.Surname,
			&employee.Phone,
			&employee.CompanyId,
			&employee.Passport.Type,
			&employee.Passport.Number,
			&employee.Department.Name,
			&employee.Department.Phone,
		)
		if err != nil {
			fmt.Println(err)
			return
		}
		employees = append(employees, employee)
	}

	// Set response headers
	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(employees)
}

/*
func updateEmployee(w http.ResponseWriter, r *http.Request) {

	//employee := Employee{}
	employee := make(map[string]interface{})
	err := json.NewDecoder(r.Body).Decode(&employee)
	if err != nil {
		fmt.Fprint(w, err)
		return
	}

	fmt.Println(employee)

	sqlParams := []sql.NamedArg{}

	prefix := map[string]string{
		"string": "vstr",
		"float64":"vint",
		"int64":"vint",
	}
	for name, val := range employee {
		fmt.Println(name)
		valtype := fmt.Sprintf("%T", val)
		fmt.Println(val, valtype)
		if valtype == "map[string]interface {}" {
			for iname, ival := range val.(map[string]interface{}) {
				valtype = fmt.Sprintf("%T", ival)
				fmt.Println(iname, ival, valtype)
			}
		}
	}

	json.NewEncoder(w).Encode(employee)
}
*/

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/employees", createEmployee).Methods("POST")
	router.HandleFunc("/employees/{Id}", deleteEmployee).Methods("DELETE")
	router.HandleFunc("/employees/company/{Id}", getEmployeeByCompany).Methods("GET")
	router.HandleFunc("/employees/department", getEmployeeByDepartment).Methods("GET")
	//router.HandleFunc("/employees/{Id}", updateEmployee).Methods("PATCH")
	http.ListenAndServe(":8080", router)
}
