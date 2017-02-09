FUNCTION SortByColumn, array, column

; This function returns a sorted array of the same size and 
; type as ARRAY, sorted over the values of the specified COLUMN.

;  ARRAY -- 2D array to sort
;  COLUMN -- The column to sort over.

On_Error, 1
   
   ; Required positional parameters.

IF N_Params() NE 2 THEN $
   Message, 'ARRAY and COLUMN parameters are required'
   
   ; Get size of the array. Check parameters.
   
s = Size(array)
IF s[0] NE 2 THEN Message, 'Input array must be 2D. Returning...'

ncolumns = s[1]
IF column GT ncolumns THEN $
   Message, "Specified COLUMN doesn't exist. Returning..."
   
   ; Sort the data by the specified column.
   
sortIndex = Sort(array[column,*])

RETURN, array[*,sortIndex]


END
