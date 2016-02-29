type Bam_pileup
    b::Ptr{Record}
    qpos::Cint
    indel::Cint
    level::Cint
    flag::Cuint
end
typealias Bam_plp Ptr{Void}
typealias Bam_plp_auto_f Ptr{Void}
typealias Bam_mplp Ptr{Void}
    
#todo ret status signal handle
function bam_plp_init(func::Function,data::Ptr{Void})
    ccall((:bam_plp_init,libhts),Bam_pileup,(Function,Ptr{Void}),func,data)
end

function bam_plp_destroy(iter::Bam_plp)
    ccall((:bam_plp_destroy,libhts),Void,(Ptr{Bam_plt},),iter)
end

function bam_plp_push(iter::Bam_plp,b::Ptr{Record})
    ccall((:bam_plp_push, libhts), Cint, (Bam_plp, Ptr{Record}),iter,b)
end

function bam_plp_next(iter::Bam_plp, _tid::Ptr{Cint}, _pos::Ptr{Cint}, _n_plp::Ptr{Cint})
    ccall((:bam_plp_next, libhts), Ptr{Bam_pileup}, (Bam_plp,Ptr{Cint},Ptr{Cint},Ptr{Cint}),iter,_tid,_pos,_n_plp)
end
function bam_plp_auto(iter::Bam_plp, _tid::Ptr{Cint}, _pos::Ptr{Cint}, _n_plp::Ptr{Cint})
    ccall((:bam_plp_auto, libhts), Ptr{Bam_pileup}, (Bam_plp,Ptr{Cint},Ptr{Cint},Ptr{Cint}),iter,_tid,_pos,_n_plp)
end
function bam_plp_set_maxcnt(iter::Bam_plp,maxcnt::Cint)
    ccall((:bam_plp_maxcnt, libhts),Void,(Bam_plp,Cint),iter,maxcnt)
end
function bam_mplp_init(n::Cint,func::Bam_plp_auto_f,data::Ptr{Ptr{Void}})
    ccall((:bam_mplp_init, libhts),Bam_mplp,(Cint,Bam_plp_auto_f,Ptr{Ptr{Void}}),n,func,data)
end
function bam_mplp_init_overlaps(iter::Bam_mplp)
    ccall((:bam_mplp_init_overlaps, libhts),Void,(Bam_mplp,), iter)
end
function bam_mplp_destroy(iter::Bam_mplp)
    ccall((:bam_mplp_destroy, libhts),Void,(Bam_mplp,), iter)
end
function bam_mplp_set_maxcnt(iter::Bam_mplp,maxcnt::Cint)
    ccall((:bam_mplp_set_maxcnt, libhts),Void,(Bam_mplp,Cint),iter,maxcnt)
end
function bam_mplp_auto(iter::Bam_mplp, _tid::Ptr{Cint}, _pos::Ptr{Cint}, _n_plp::Ptr{Cint}, plp::Ptr{Ptr{Bam_pileup}})
    ccall((:bam_mplp_auto, libhts),Cint,(Bam_plp,Ptr{Cint},Ptr{Cint},Ptr{Cint}),iter,_tid,_pos,_n_plp, plp)
end
