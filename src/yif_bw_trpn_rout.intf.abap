interface YIF_BW_TRPN_ROUT
  public .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create class
    "! @raising ycx_bw_trpn | <p class="shorttext synchronized" lang="en">Error durig class creation</p>
    METHODS create_class
      RAISING ycx_bw_trpn.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Show created class
    METHODS show_class.


endinterface.
